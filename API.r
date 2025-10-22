# install the DataOne an ddatapack Packages
# install.packages("dataone")
# install.packages("datapack")

# include the libraries
library(dataone)
library(datapack)
library(uuid)

# connect to a coordinating node, set to PROD for staging data
coord_node <- CNode( "STAGING" )

# then connect that coordinating node to a member node to upload data to
member_node <- getMNode( coord_node, "urn:node:mnSandboxUCSB1" )

# get a file path to what will be uploaded, get a metadat path too
local_data_path = "data.csv"
metadata_path = "metadata.csv"

# get the file/data format (eg. csv)
data_format <- "file/csv"

# create data package object
data_package <- new("DataPackage")

# put the data and metadata into an object
data_obj <- new("DataObject", format=data_format, filename=local_data_path)
metadata_obj <- new("DataObject", filename=metadata_path)

# add the data objects into the dataPackage
data_package <- addMember( data_package, data_obj )
data_package <- addMember( data_package, metadata_obj )

# upload it
package_id <- uploadDataPackage(mn, dp)
print(packages_id)
