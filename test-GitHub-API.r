# install libraries if needed
# install.packages("httr")
# install.packages("jsonlite")
# install.packages("base64enc")

# include libraries
library(httr)
library(jsonlite)
library(base64enc)

# get owner and repo info
USERNAME = "Hcr64"
REPO = "Geri-DataOne-API"

# get the personal Access Token
PAT = ""

# make a function to create a github file and add it to the repo
create_gh_file_to_repo <- function( f_path, f_content, commit_msg="Add new file from API" )
{
  # encode to b64
  encoded <- base64encode( charToRaw( f_content ) )
  
  # get the complete repo address
  repo_url <- paste0( "https://api.github.com/repos/", USERNAME, "/", REPO, "/contents/", f_path )
  
  # prep request body as list, convert to json
  req_body <- list(
    message = commit_msg,
    content = encoded
  )
  
  # convert to json
  req_body_json <- toJSON( req_body, auto_unbox=TRUE )
  
  # make put request
  put_req <- PUT(
    repo_url,
    add_headers(
      Authorization = paste("token", PAT),
      Accept = "application/vnd.github.v3+json"
    ),
    body = req_body_json,
    encode = "json"
  )
  
  # get response
  if( status_code(put_req) == 201)
  {
    # success
    print("Success!\n")
    return(content(put_req))
  }
  
  else
  {
    # failure
    print("No Good :(\n")
    return(NULL)
  }
}

# call the function
result <- create_gh_file_to_repo("test_file2.txt", "new text file stuff", "Create test_file.txt and testing")
print(result)

