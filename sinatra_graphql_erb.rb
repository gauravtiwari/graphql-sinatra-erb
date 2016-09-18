IndexQuery = API::Client.parse <<-'GRAPHQL'
  query {
    root {
      id,
      tags,
      posts(first: 10) {
        edges {
          node {
            id,
            title,
            slug,
            excerpt,
            voted,
            user_id,
            created_at,
            comments_count,
            tags,
            votes_count,
            user {
              name,
            }
          }
        }
        pageInfo {
          hasNextPage
        }
      }
    }
  }
GRAPHQL

ShowQuery = API::Client.parse <<-'GRAPHQL'
  query($id: ID!) {
    node(id: $id) {
      id
      ... on Post {
        id,
        title,
        slug,
        body,
        voted,
        user_id,
        created_at,
        comments_count,
        tags,
        votes_count,
        user {
          name,
        }
        comments(first: 10, order: "-id") {
          edges {
            node {
              id,
              votes_count,
              voted,
              id,
              body,
              is_owner,
              votes_count,
              voted,
              created_at,
              user {
                name,
              },
            }
          },
          pageInfo {
            hasNextPage
          }
        }
      }
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
      posts: data.root.posts
    }
  end


  get '/posts/:id' do
    data = query ShowQuery, id: params["id"]
    erb :show, locals: {
      post: data.node,
      comments: data.node.comments
    }
  end
end
