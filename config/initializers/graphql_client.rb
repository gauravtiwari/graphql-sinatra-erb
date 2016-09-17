module API
  HTTPAdapter = GraphQL::Client::HTTP.new(ENV['API_URL']) do
    def headers(context)
      {
        "Authorization" => "Bearer #{ENV['ACCESS_TOKEN']}"
      }
    end
  end

  GraphQL::Client.dump_schema(HTTPAdapter, './db/schema.json')

  Client = GraphQL::Client.new(
    schema: GraphQL::Client.load_schema('./db/schema.json'),
    execute: HTTPAdapter
  )
end
