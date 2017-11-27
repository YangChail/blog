PID_FILE=./serverPid.pid  
RUN_SCRIPT=nohup hexo server -p 80 >logs/logs.log 2>&1 &

echo "start? stop? restart? "  
read key  
case "$key" in  
    start)  
    if [ ! -f $PID_FILE ]; then   
    echo "server starting ..."  
    $RUN_SCRIPT  
    echo $! > $PID_FILE   
    echo "server started"  
    else   
    echo "server is already started"  
    fi    
    ;;  
    stop)  
    if [ -f $PID_FILE ]; then   
    PID=$(cat $PID_FILE);  
    echo "server stoping ..."  
    kill -9 $PID;  
    rm $PID_FILE  
    echo "server stoped"  
    else  
    echo "server is already stoped"  
    fi  
    ;;  
    restart)  
    if [ -f $PID_FILE ]; then  
    PID=$(cat $PID_FILE);  
    echo "server stoping ..."  
    kill -9 $PID;  
    rm $PID_FILE  
    echo "server stoped"  
    echo "restart ..."  
    echo "server starting ..."  
        $RUN_SCRIPT
        echo $! > $PID_FILE  
        echo "server started"  
    else  
    echo "server starting ..."  
        $RUN_SCRIPT   
        echo $! > $PID_FILE  
        echo "server started"  
    fi  
    ;;  
esac