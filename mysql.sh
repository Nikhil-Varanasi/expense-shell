#! /bin/bash
LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME="$(echo $0 | cut -d "." -f1)"
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R please run the script with root proivilages $N" | tee -a $LOG_FILE
        exit 1
    fi
}        

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 was $R not  sucessfull $N..look in to it.." | tee -a $LOG_FILE
        exit 1
    else
        echo "$2 was $G successfull $N" | tee -a $LOG_FILE
    fi    
}        

CHECK_ROOT

echo "script started executing at :: $(date)" | tee -a $LOG_FILE

dnf install mysql-server -y
VALIDATE $? "installing mysql server"

systemctl enable mysqld
VALIDATE $? "enableing mysql server"

systemctl start mysqld
VALIDATE $? "starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "setting up root password"


