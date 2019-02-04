__author__ = 'mmadaio'

import pandas as pd
import feather

# Set input and output folders
# output = "/var/www/html/"

# Read fire risk data
risk = pd.read_csv('/home/linadmin/FirePred/datasets/Results.csv', low_memory = False)

# Read City of Pittsburgh property data
pitt = pd.read_csv("/home/linadmin/FirePred/datasets/pittdata.csv", low_memory = False)

# Read City of Pittsburgh parcel data
parcels = pd.read_csv("/home/linadmin/FirePred/datasets/parcels.csv", low_memory = False)

# Format addresses in Pitt property data
pitt['HouseNum'] = pitt['PROPERTYHOUSENUM'].astype(str).map(lambda x: x.rstrip('.0'))
pitt['NewAddress'] = pitt['HouseNum'].astype(str) + " " + pitt['PROPERTYADDRESS']
pitt = pitt[(pitt.PROPERTYCITY == 'PITTSBURGH')]


# Merge risk to pitt
pitt_risk = pd.merge(left=risk,right=pitt, how='left', left_on='Address', right_on='NewAddress')

del pitt_risk['NewAddress']
del pitt_risk['HouseNum']
del pitt_risk['Unnamed: 0']

# Merge pitt_risk to parcels
pitt_risk_parcels = pd.merge(left=pitt_risk,right=parcels, how='left', left_on='PARID', right_on='PIN')

# Filter out everything but properties in Pittsburgh Municipality
pitt_risk_parcels = pitt_risk_parcels[pitt_risk_parcels['MUNIDESC'].str.contains("Ward|Ingram|Wilkinsburg",na=False)]

# String Columns to list
string_cols = list(pitt_risk_parcels.select_dtypes(exclude=['float64', 'int', 'bool']))

# Encoding issue when writing to feather
for column in string_cols:
    pitt_risk_parcels[column] = pitt_risk_parcels[column].astype(unicode)
        
# Output to feather
feather.write_dataframe(pitt_risk_parcels, '/var/www/html/fire_risk_nonres.feather')