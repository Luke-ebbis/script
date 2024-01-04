point_to_coords <- function(dataframe, point_var) {
    point <- dataframe |> dplyr::pull(!!point_var)
    longs <- stringr::str_extract(point, "Point\\((\\d+.\\d+) (\\d+.\\d+)\\)", 
                                  group = 1) |> as.numeric()
    lats <- stringr::str_extract(point, "Point\\((\\d+.\\d+) (\\d+.\\d+)\\)", 
                                  group = 2) |> as.numeric()
    print(point)
    dat <- sf::st_as_sf(dataframe |> 
                            dplyr::mutate(long = longs,
                                          lat = lats), coords = c("long", "lat"), crs = 4326)    
    dat
}
query_fuseki <- function(query,
                         base = "http://localhost:3034/ds/sparql?query=") {
    encoded <- URLencode(query, reserved = TRUE)
    
    headers <- c(
        "Accept" = "text/csv"
    )
    rq <- httr2::request(paste0(base, encoded)) |> 
        httr2::req_headers("Accept" = headers) |> 
        httr2::req_perform()
    out <- rq |> httr2::resp_body_string()
    
    dft <- read.table(text = out, sep =",",
                      header = TRUE, stringsAsFactors = FALSE)
    dft
}
