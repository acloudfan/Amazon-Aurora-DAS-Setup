import json
import base64
import os
import boto3
import zlib

# Used for decryption of the received payload
import aws_encryption_sdk
from aws_encryption_sdk import CommitmentPolicy
from aws_encryption_sdk.internal.crypto import WrappingKey
from aws_encryption_sdk.key_providers.raw import RawMasterKeyProvider
from aws_encryption_sdk.identifiers import WrappingAlgorithm, EncryptionKeyType

import processor.heartbeat_processor as heartbeat_processor
import processor.sqlevents_processor as sqlevents_processor

from processor import heartbeat_processor
from processor import sqlevents_processor

# Controls the filtering of Heartbean events
FILTER_HEARTBEAT_EVENTS = os.getenv('FILTER_HEARTBEAT_EVENTS', "false").lower() ==  "true"

# Setup the session | clients
REGION_NAME= os.environ['AWS_REGION']
session = boto3.session.Session()
kms = session.client('kms', region_name=REGION_NAME)

# Create the encryption client
enc_client = aws_encryption_sdk.EncryptionSDKClient(commitment_policy=CommitmentPolicy.REQUIRE_ENCRYPT_ALLOW_DECRYPT)

# Represents the Master Key Provider
class MyRawMasterKeyProvider(RawMasterKeyProvider):
    provider_id = "BC"

    def __new__(cls, *args, **kwargs):
        obj = super(RawMasterKeyProvider, cls).__new__(cls)
        return obj

    def __init__(self, plain_key):
        RawMasterKeyProvider.__init__(self)
        self.wrapping_key = WrappingKey(wrapping_algorithm=WrappingAlgorithm.AES_256_GCM_IV12_TAG16_NO_PADDING,
                                        wrapping_key=plain_key, wrapping_key_type=EncryptionKeyType.SYMMETRIC)

    def _get_raw_key(self, key_id):
        return self.wrapping_key



# Decrypt the payload using the key and then decompress (zip to plaintext)
def decrypt_decompress(payload, key):
    my_key_provider = MyRawMasterKeyProvider(key)
    my_key_provider.add_master_key("DataKey")
    decrypted_plaintext, header = enc_client.decrypt(
        source=payload,
        materials_manager=aws_encryption_sdk.materials_managers.default.DefaultCryptoMaterialsManager(master_key_provider=my_key_provider))
    
    # print(decrypted)
    return zlib.decompress(decrypted_plaintext, zlib.MAX_WBITS + 16)
    

# Lambda Handler function
def lambda_handler(event, context):

    # Output is an array of transformed records
    output = []
    heartBeatEventRecords = heartbeat_processor.HeartBeatEventRecords()
    sQLEventRecords = sqlevents_processor.SQLEventRecords()
    
    
    for record in event['records']:
        
        # Get the data from record - it is in base64 format
        data = record['data']
        payload_overall = base64.b64decode(data)
        payload_overall = payload_overall.decode('utf-8')
        
        # Parse the json payload
        payload_overall_json=json.loads(payload_overall)
        
        # Get the base64 decoded databaseActivityEvents array from the record
        payload_decoded = base64.b64decode(payload_overall_json['databaseActivityEvents'])
        
        
        # Decrypt the key
        # RESOURCE_ID = Cluster ID of the RDS instance
        RESOURCE_ID = os.environ['RESOURCE_ID']
        
        # Decrypt
        data_key_decoded = base64.b64decode(payload_overall_json['key'])
        data_key_decrypt_result = kms.decrypt(CiphertextBlob=data_key_decoded, EncryptionContext={'aws:rds:dbc-id': RESOURCE_ID})
            
        # Decrypt the data
        # print(data_key_decrypt_result['Plaintext'])
        data_decrypted_decompressed =  decrypt_decompress(payload_decoded, data_key_decrypt_result['Plaintext'])
        
        # Parse the JSON
        data_decrypted_decompressed_json =json.loads(data_decrypted_decompressed)
        
        if data_decrypted_decompressed_json['databaseActivityEventList'][0]['type'] == "heartbeat" :
            # print(data_decrypted_decompressed_json)
            heartBeatEventRecords.add(record['recordId'], data_decrypted_decompressed_json,record['approximateArrivalTimestamp'])
        else:
            sQLEventRecords.add(record['recordId'], data_decrypted_decompressed_json, record['approximateArrivalTimestamp'])
            
            
    # output.append(heartBeatEventRecords.process(FILTER_HEARTBEAT_EVENTS))
    # output.append(sQLEventRecords.process())
    
    # output_hb = heartBeatEventRecords.process(FILTER_HEARTBEAT_EVENTS)
    
    output_hb = heartBeatEventRecords.process(FILTER_HEARTBEAT_EVENTS)
    output_sql = sQLEventRecords.process()
    

    
    print('Total records processed {} records.'.format(len(output_hb)+len(output_sql)))

    
    return {'records': output_hb + output_sql }
