import pandas as pd
import os
import time
from datetime import datetime, timedelta

# Configuration
SOURCE_FILE = "AI_Human.parquet"
HDFS_BASE_PATH = "/education/spring_gr01/login/project/staged_data"
CHUNKS = 1000
INTERVAL_SEC = 300  # 5 minutes

def get_custom_time():
    now = datetime.now()
    # Round minutes down to the nearest 5 (e.g., 14:07 becomes 14:05)
    custom_hour = now ## + timedelta(hours=2)
    rounded_minute = (custom_hour.minute // 5) * 5
    return custom_hour.replace(minute=rounded_minute, second=0, microsecond=0)

def stream_to_hdfs():
    df = pd.read_parquet(SOURCE_FILE)
    # Split dataframe into chunks
    chunk_size = len(df) // CHUNKS
    
    for i in range(CHUNKS):
        # 1. Prepare timestamped folder name
        folder_time = get_custom_time()
        folder_name = folder_time.strftime("%Y/%m/%d/%H%M")
        full_path = f"{HDFS_BASE_PATH}/{folder_name}"
        
        # 2. Get the chunk
        start_row = i * chunk_size
        end_row = (i + 1) * chunk_size
        subset = df.iloc[start_row:end_row]
        
        # 3. Write locally then push to HDFS
        local_tmp = f"chunk_{i}.parquet"
        subset.to_parquet(local_tmp)
        
        print(f"Uploading batch {i} to {full_path}...")
        os.system(f"hdfs dfs -mkdir -p {full_path}")
        os.system(f"hdfs dfs -put {local_tmp} {full_path}/data.parquet")
        
        # 4. THE TRIGGER: Create the _SUCCESS file
        os.system(f"hdfs dfs -touchz {full_path}/_SUCCESS")
        
        print(f"Batch {i} ready. Sleeping...")
        os.remove(local_tmp)
        time.sleep(INTERVAL_SEC)

if __name__ == "__main__":
    stream_to_hdfs()
