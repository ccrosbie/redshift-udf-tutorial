__author__ = 'ccrosbie'
import psycopg2 as redshift
#if having issues installing psycopg2 try
#sudo find / -name "pg_config" -print
#and then set your path to the location of that package
#PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin/

global_table_name = "unstructured_table_here"
export_table = "CMS.x"

configuration = { 'dbname': 'YOURDBNAMEHERE',
                  'user':'YOURUSERHERE',
                  'pwd':'YOURPWDHERE',
                  'host':'YOURHOSTHERE',
                  'port':'5439'
                }

def create_conn(*args,**kwargs):

    config = kwargs['config']
    conn=redshift.connect(dbname=config['dbname'], host=config['host'], port=config['port'], user=config['user'], password=config['pwd'])
    return conn


def select(strSQL, *args,**kwargs):
    # need a connection with dbname=<username>_db
    cur = kwargs['cur']

    try:
        # retrieving all tables in my search_path
        cur.execute(strSQL)
    except Exception as err:
            print err

    return cur.fetchall()

#    rows = cur.fetchall()
#    for row in rows:
#        print row


print 'start'
findtable = """select distinct column_name,ordinal_position from INFORMATION_SCHEMA.COLUMNS where table_name = '""" + global_table_name + "' order by ordinal_position ; """
print findtable
conn = create_conn(config=configuration)
cursor = conn.cursor()
cursor2 = conn.cursor()
tableDDL = "CREATE TABLE " + export_table + " ("
for x in select(cur=cursor,strSQL=findtable):
    findColLengthSQL =  "select max(char_length(" + x[0] + ")) + 1 from " + global_table_name + ";"
    for y in select(cur=cursor2,strSQL=findColLengthSQL):
        tableDDL += x[0] + " varchar(" + str(y[0]) + '),'
        print x[0]

tableDDL += ');'
cursor.close()
cursor2.close()

fo = open(global_table_name + ".sql", "w")
fo.write(tableDDL)
fo.close()

tableDDL
print 'finish'


