# NowPlaying

A tvOS version of the Raspberry PI HTML app here:  
https://github.com/donwb/videowall

Uses the same API

Thread 131: Fatal error: 'try!' expression unexpectedly raised an error: 
Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: 
"The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 
"Invalid value around line 1, column 6." UserInfo={NSDebugDescription=Invalid value around line 1, column 6., NSJSONSerializationErrorIndex=6})))


query for getting stats
http://localhost:1323/api/stats/May%202022/10
likely need to escape out the date portion (or add the %20 manually lol)

