import json
import base64

# Class for processing the Database Activity events of type=record
class SQLEventRecords():
    records = []
    # Initialize
    def __init__(self):
        print('SQLEventRecords')
        
    # Add the db activity record to the local array
    def add(self,recordId, record, approximateArrivalTimestamp):
        self.records.append((recordId, record, approximateArrivalTimestamp))
    
    # Process the DB activity event records
    def process(self):
        print('HB processing count = %'.format(len(self.records)))
        output_records = []
        
        # Loop through the records received in the stream
        for record in self.records:
            # convert JSON to string
            record_send = json.dumps(record[1])
            
            record_send= record_send + '\n'
            
            # No change to the record
            output_record = {
                'recordId': record[0],
                'result': 'Ok',
                'data': base64.b64encode(record_send.encode()).decode("ascii")
            }
            output_records.append(output_record)
        
        return output_records