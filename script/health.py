import psutil
def threshold_check():
    user_cpu_threshold= float(input("Enter CPU threshold value : "))
    user_disk_threshold = float(input("Enter Disk threshold : "))
    user_memory_threshold = float(input("Enter Memory threshold : "))
    user_process_threshold = float(input("Enter Process threshold : "))

    cpu_threshold= psutil.cpu_percent(interval=1)
    disk_threshold = psutil.disk_usage('/').percent
    memory_threshold = psutil.virtual_memory().percent
    process_threshold = len(psutil.pids())

    print("\t\tYour Metric\t\tSystem Metric")
    print("CPU\t\t",user_cpu_threshold,"\t\t\t",cpu_threshold)
    print("Disk\t\t",user_disk_threshold,"\t\t\t",disk_threshold)
    print("Memory\t\t",user_memory_threshold,"\t\t\t",memory_threshold)
    print("Process\t\t",user_process_threshold,"\t\t\t",process_threshold)
    
    if cpu_threshold  > user_cpu_threshold:
        print("ALERT : CPU usage exceeds threshold")
    else:
        print("CPU usage is within threshold")
    if disk_threshold  > user_disk_threshold:
        print("ALERT : Disk usage exceeds threshold")
    else:
        print("Disk usage is within threshold")
    if memory_threshold > user_memory_threshold:
        print("ALERT : Memory usage exceeds threshold")
    else:
        print("Memory usage is within threshold")
    if process_threshold > user_process_threshold:
        print("ALERT : Process count exceeds threshold")
    else:
        print("Process count is within threshold")

threshold_check()
