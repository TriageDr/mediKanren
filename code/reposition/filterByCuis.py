#!/usr/bin/python
import mysql.connector as mariadb
import pandas as pd
import os
import sys

#Variables
outputpath = '../../../mediKanrenAutomatedQueries/alzfiltered/'
inputpath = "../../../mediKanrenAutomatedQueries/alz"


# Functions
def filterDF(colheader,filterdict,df,outfile):
   testdf = df[df[colheader].str.contains(filterdict)]
   if(testdf.shape[0]>0):
     outfile = outputpath+name
     testdf.to_csv(outfile, sep='\t', index=False)



mariadb_connection = mariadb.connect(user='umls', password='umls', database='umls2019ab', host='138.26.120.14')
cursor = mariadb_connection.cursor()

if(len(sys.argv)!=3):
    print("Usage: filterByCuis inputpath, outputpath")
inputpath=sys.argv[1]
outputpath=sys.argv[2]
print("Inputpath:"+inputpath)
print("Outputpath:"+outputpath)

# Parse repodb
repodf = pd.read_csv('repodbCUImap.txt',encoding = 'utf-8',delimiter='\t')
#print(repodf.head(1))
filter_dict = repodf['DrugCUI'].to_dict()
#print(filter_dict)
filter_set = set(filter_dict.values())
kwstr = '|'.join(sorted(filter_set))
#print(len(filter_set))
#print(kwstr)

# Build filter
for root, dirs, files in os.walk(inputpath, topdown=False):
   for name in files:
      if(name.endswith("csv") or name.endswith("tsv")):
        filein=os.path.join(root, name)
        result = pd.read_csv((filein),encoding = 'utf-8',delimiter='\t')
        #print(result.head(1))
        if 'drug_id' in result:
           filterDF("drug_id",kwstr,result,outputpath+name)
        elif ('subject_curie' in result) and (name.find("DRUGS")!=-1):
           filterDF("subject_curie",kwstr,result,outputpath+name)
