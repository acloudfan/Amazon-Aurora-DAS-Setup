import json
import base64

class SQLEventRecords():
    records = []
    # Initialize
    def __init__(self):
        print('SQLEventRecords')
        
    def add(self,recordId, record, approximateArrivalTimestamp):
        self.records.append((recordId, record, approximateArrivalTimestamp))
    
    # Returns an array of processed heartbeat records
    def process(self):
        print('HB processing count = %'.format(len(self.records)))
        output_records = []
        
        
        
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