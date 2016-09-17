IndexQuery = API::Client.parse <<-'GRAPHQL'
  query {
    all_posts {
      id
      title
      body
    }
  }
GRAPHQL

ShowQuery = API::Client.parse <<-'GRAPHQL'
  query($id: ID!) {
    post(id: $id) {
      id
      title
      body
    }
  }
GRAPHQL

class SinatraGraphqlErb < Sinatra::Base
  set public_folder: 'public', static: true
  use Rack::Session::Cookie, secret: 'super_secret_client_key'
  use Rack::Protection
  use Rack::Protection::RemoteReferrer

  private

  def query(definition, variables = {})
    response = API::Client.query(
      definition,
      variables: variables,
      context: client_context
    )

    case response
    when GraphQL::Client::SuccessfulResponse
      response.data
    when GraphQL::Client::FailedResponse
      raise response.errors
    end
  end

  def client_context
    { access_token: ENV['ACCESS_TOKEN'] }
  end

  get '/' do
    data = query IndexQuery
    erb :index, locals: {
      posts: data.all_posts
    }
  end

  get '/posts/:id' do
    data = query ShowQuery, id: params["id"]
    erb :show, locals: {
      post: data.post
    }
  end
end
