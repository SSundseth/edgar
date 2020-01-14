import mysql.connector
from mysql.connector import Error

try:
    connection = mysql.connector.connect(host='localhost',
                                         database='edgar',
                                         user='root',
                                         password='Ba5eba!!')
    cursor = connection.cursor()
    
    cursor.execute("load data infile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/dataAddition.csv' into table raw_data FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'")

    cursor.execute('truncate raw_data_daily')
    cursor.execute("load data infile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/data.csv' into table raw_data_daily FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'")

    connection.commit()

    cursor.callproc('daily_reload')


    connection.commit()

except mysql.connector.Error as error:
    print("Failed to execute stored procedure: {}".format(error))
finally:
    if (connection.is_connected()):
        cursor.close()
        connection.close()
        print("MySQL connection is closed")
