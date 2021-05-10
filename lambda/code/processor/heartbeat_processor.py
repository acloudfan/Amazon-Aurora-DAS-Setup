import json
import base64

# Class for processing the Heartbeat events
class HeartBeatEventRecords():
    records = []
    
    # Initialize
    def __init__(self):
        print('HeartBeatEventRecords initialized')
        
    def add(self, recordId, record, approximateArrivalTimestamp):
        self.records.append((recordId, record, approximateArrivalTimestamp))
        
    
    # Returns an array of processed heartbeat records
    def process_no_change_or_ignore(self, ignore_all):
        # print('HB processing count = %'.format(len(self.records)))
        output_records = []
        
        
        # Decide whether to filter the Heartbeats
        if ignore_all:
            print('HeartBeat Records Filtered ....count={}'.format(len(self.records)))
            result = 'Dropped'
        else:
            print('HeartBeat Records Processed ....count={}'.format(len(self.records)))
            result = 'Ok'
        
        # Loop through the event records and write out to the stream
        for record in self.records:
            # convert JSON to string
            (record[1])['approximateArrivalTimestamp']=record[2]
            record_send = json.dumps(record[1])
            
            # No change to the record
            output_record = {
                'recordId': record[0],
                'result': result,
                'data': base64.b64encode(record_send.encode()).decode("ascii")
            }
            output_records.append(output_record)
        
        return output_records

        
    # Gets called from the main handler for processing the heartbet events
    def process(self,flag):
        return self.process_no_change_or_ignore(flag)
