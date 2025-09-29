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
create_gh_file_to_repo <- function( f_path, local_f_path, commit_msg="Add new file from API" )
{
  # get the file content from the local file
  f_content <- readLines( file( local_f_path, "r" ) )

  # encode to b64
  encoded <- base64encode( charToRaw( paste( f_content, collapse="\n" ) ) )
  
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
  if( status_code(put_req) == 200)
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

# a function that appends to a file in github
append_github_file <- function( f_name, new_file, commit_msg="Added text to file")
{
  # get the file content from the local file
  f_content <- paste( readLines( file( f_name, "r" ) ), collapse="\n" )
  
  # get the new encoded file content
  new_f_content <- paste( readLines( file( new_file, "r" ) ), collapse="\n" )
  
  # get the combined text
  combined_text = paste0( f_content, "\n", new_f_content )
  print(combined_text)
  
  # encode to b64
  encoded <- base64encode( charToRaw( combined_text ) ) 
}

# call the function
# result <- create_gh_file_to_repo("test_file5.txt", "Geri-DataOne-API/README.md", "Create test_file.txt and testing")
# print(result)
append_github_file("Geri-DataOne-API/README.md", "Geri-DataOne-API/README.md")
