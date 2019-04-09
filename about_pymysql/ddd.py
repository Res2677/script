import pymysql
db= pymysql.connect(host="localhost",user="hangjf",
 	password="resister2677",db="test",port=3307)
cur = db.cursor()
