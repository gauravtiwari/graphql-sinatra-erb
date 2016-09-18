module API
  HTTPAdapter = GraphQL::Client::HTTP.new(ENV['API_URL'])

  #
    # Pass block to send auth token
    # def headers(context)
    #   {
    #     "Authorization" => "Bearer #{ENV['ACCESS_TOKEN']}"
    #   }
    # end
  #

  GraphQL::Client.dump_schema(HTTPAdapter, './api/schema.json')

  Client = GraphQL::Client.new(
    schema: GraphQL::Client.load_schema('./api/schema.json'),
    execute: HTTPAdapter
  )
end
