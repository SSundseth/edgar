import mysql.connector
from mysql.connector import Error

try:
    connection = mysql.connector.connect(host='localhost',
                                         database='edgar',
                                         user='root',
                                         password='Ba5eba!!',
                                         connection_timeout=36000)
    cursor = connection.cursor()
    

    cursor.execute('truncate raw_data_daily')
    connection.commit()

    cursor.execute("load data infile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/data.csv' into table raw_data_daily FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'")
    connection.commit()

    # Delete old records for this cik. If they are in a new file then they are for a new quarter
    cursor.execute("delete from raw_data where cik in (select cik from raw_data_daily)");
    connection.commit()

    cursor.execute("insert into raw_data select * from raw_data_daily");
    connection.commit()

    # Load data that was a 13F HR/A
    cursor.execute("load data infile 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/dataAddition.csv' into table raw_data FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'")
    connection.commit()

    print('Calling calculation procedure')
    cursor.callproc('daily_reload')
    connection.commit()

except mysql.connector.Error as error:
    print("Failed to execute stored procedure: {}".format(error))
finally:
    if (connection.is_connected()):
        cursor.close()
        connection.close()
        print("MySQL connection is closed")
