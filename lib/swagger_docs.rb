module MetadataRegistry
  # Swagger docs definition
  class SwaggerDocs
    include Swagger::Blocks

    swagger_path '/' do
      operation :get do
        key :operationId, 'getApi'
        key :description, 'Show the README rendered in HTML'
        key :produces, ['text/html']
        response 200, description: 'shows the README rendered in HTML'
      end
    end

    swagger_path '/api' do
      operation :get do
        key :operationId, 'getApi'
        key :description, 'API root'
        key :produces, ['application/json']

        response 200 do
          key :description, 'API root'
          schema { key :'$ref', :ApiRoot }
        end
      end
    end

    swagger_path '/api/info' do
      operation :get do
        key :operationId, 'getApiInfo'
        key :description, 'General info about this API node'
        key :produces, ['application/json']

        response 200 do
          key :description, 'General info about this API node'
          schema { key :'$ref', :ApiInfo }
        end
      end
    end

    swagger_path '/api/schemas/info' do
      operation :get do
        key :operationId, 'getApiSchemasInfo'
        key :description, 'General info about the json-schemas'
        key :produces, ['application/json']

        response 200 do
          key :description, 'General info about the json-schemas'
          schema { key :'$ref', :SchemasInfo }
        end
      end
    end

    swagger_path '/api/schemas/{schema_name}' do
      operation :get do
        key :operationId, 'getApiSchema'
        key :description, 'Get the corresponding json-schema'
        key :produces, ['application/json']

        parameter name: :schema_name,
                  in: :path,
                  type: :string,
                  required: true,
                  description: 'Unique schema name'

        response 200, description: 'Get the corresponding json-schema'
      end
    end

    swagger_path '/api/{community_name}' do
      operation :get do
        key :operationId, 'getApiCommunity'
        key :description, 'Retrieve metadata community'
        key :produces, ['application/json']

        parameter name: :community_name,
                  in: :path,
                  type: :string,
                  required: true,
                  description: 'Unique community name'

        response 200 do
          key :description, 'Retrieve metadata community'
          schema { key :'$ref', :Community }
        end
      end
    end

    swagger_path '/api/{community_name}/info' do
      operation :get do
        key :operationId, 'getApiCommunityInfo'
        key :description, 'General info about this metadata community'
        key :produces, ['application/json']

        parameter name: :community_name,
                  in: :path,
                  type: :string,
                  required: true,
                  description: 'Unique community name'

        response 200 do
          key :description, 'General info about this metadata community'
          schema { key :'$ref', :CommunityInfo }
        end
      end
    end

    swagger_path '/api/{community_name}/envelopes' do
      operation :get do
        key :operationId, 'getApiEnvelopes'
        key :description, 'Retrieves all community envelopes ordered by date'
        key :produces, ['application/json']

        parameter name: :community_name,
                  in: :path,
                  type: :string,
                  required: true,
                  description: 'Unique community name'
        parameter name: :page,
                  in: :query,
                  type: :integer,
                  format: :int32,
                  default: 1,
                  required: false,
                  description: 'Page number'
        parameter name: :per_page,
                  in: :query,
                  type: :integer,
                  format: :int32,
                  default: 10,
                  required: false,
                  description: 'Items per page'

        response 200 do
          key :description, 'Retrieves all envelopes ordered by date'
          schema do
            key :type, :array
            items { key :'$ref', :Envelope }
          end
        end
      end

      operation :post do
        key :operationId, 'postApiEnvelopes'
        key :description, 'Publishes a new envelope'
        key :produces, ['application/json']
        key :consumes, ['application/json']

        parameter name: :community_name,
                  in: :path,
                  type: :string,
                  required: true,
                  description: 'Unique community name'
        parameter name: :update_if_exists,
                  in: :query,
                  type: :boolean,
                  required: false,
                  description: 'Whether to update the envelope if exists'
        parameter name: :Envelope,
                  in: :body,
                  required: true,
                  schema: { '$ref': :PostRequestEnvelope }

        response 200 do
          key :description, 'Envelope updated'
          schema { key :'$ref', :Envelope }
        end
        response 201 do
          key :description, 'Envelope created'
          schema { key :'$ref', :Envelope }
        end
        response 422 do
          key :description, 'Validation Error'
          schema { key :'$ref', :ValidationError }
        end
      end

      operation :put do
        key :description, 'Marks envelopes as deleted'
        key :operationId, 'putApiEnvelopes'
        key :description, 'Publishes a new envelope'
        key :produces, ['application/json']
        key :consumes, ['application/json']

        parameter name: :community_name,
                  in: :path,
                  type: :string,
                  required: true,
                  description: 'Unique community name'
        parameter name: :envelope_id,
                  in: :body,
                  type: :string,
                  required: true,
                  description: 'The id for the Envelope to be deleted'
        parameter name: :DeleteToken,
                  in: :body,
                  required: true,
                  schema: { '$ref': :DeleteToken }

        response 204 do
          key :description, 'Mathcing envelopes marked as deleted'
        end
        response 404 do
          key :description, 'No envelopes match the envelope_id'
        end
        response 422 do
          key :description, 'Validation Error'
          schema { key :'$ref', :ValidationError }
        end
      end
    end

    # ==========================================
    # Schemas

    swagger_schema :ApiRoot do
      property :api_version,
               type: :string,
               description: 'API version number'
      property :total_envelopes,
               type: :integer,
               format: :int32,
               description: 'Total count of metadata envelopes'
      property :metadata_communities,
               type: :object,
               description: 'Object with community names and their API urls'
      property :info,
               type: :string,
               description: 'URL for the API info'
    end

    swagger_schema :ApiInfo do
      property :metadata_communities,
               type: :object,
               description: 'Object with community names and their API urls'
      property :postman,
               type: :string,
               description: 'URL for the postman collection'
      property :swagger,
               type: :string,
               description: 'URL for the Swagger docs'
      property :readme,
               type: :string,
               description: 'URL for the repo\'s README doc'
      property :docs,
               type: :string,
               description: 'URL for the docs folder'
    end

    swagger_schema :SchemasInfo do
      property :available_schemas,
               type: :array,
               description: 'List of json-schema URLs available',
               items: { type: :string, description: 'json-schema URL' }
      property :specification,
               type: :string,
               description: 'URL for the json-schema spec'
    end

    swagger_schema :Community do
      property :id,
               type: :integer,
               format: :int32,
               description: 'Community id'
      property :name,
               type: :string,
               description: 'Community name'
      property :backup_item,
               type: :string,
               description: 'Backup item name on Internet Archive'
      property :default,
               type: :boolean,
               description: 'Wether this is the default Community or not'
      property :created_at,
               type: :string,
               format: :'date-time',
               description: 'When the version was created'
      property :updated_at,
               type: :string,
               format: :'date-time',
               description: 'When the version was updated'
    end

    swagger_schema :CommunityInfo do
      property :total_envelopes,
               type: :integer,
               format: :int32,
               description: 'Total count of envelopes for this community'
      property :backup_item,
               type: :string,
               description: 'Internet Archive backup item identifier'
    end

    swagger_schema :Envelope do
      key :description, 'Retrieves a specific envelope version'

      property :envelope_id,
               type: :string,
               description: 'Unique identifier (in UUID format)'
      property :envelope_type,
               type: :string,
               description: 'Type ("resource_data" or "paradata")'
      property :envelope_version,
               type: :string,
               description: 'Envelope version used'
      property :resource,
               type: 'string',
               description: 'Resource in its original encoded format'
      property :decoded_resource,
               type: 'string',
               description: 'Resource in decoded form'
      property :resource_format,
               type: 'string',
               description: 'Format of the submitted resource'
      property :resource_encoding,
               type: 'string',
               description: 'Encoding of the submitted resource'
      property :node_headers,
               description: 'Additional headers added by the node',
               '$ref': :NodeHeaders
    end

    swagger_schema :NodeHeaders do
      property :resource_digest,
               type: :string
      property :versions,
               type: :array,
               items: { '$ref': :Version },
               description: 'Versions belonging to the envelope'
      property :created_at,
               type: :string,
               format: :'date-time',
               description: 'Creation date'
      property :updated_at,
               type: :string,
               format: :'date-time',
               description: 'Last modification date'
      property :deleted_at,
               type: :string,
               format: :'date-time',
               description: 'Deletion date'
    end

    swagger_schema :Version do
      property :head,
               type: :boolean,
               description: 'Tells if it\'s the current version'
      property :event,
               type: :string,
               description: 'What change caused the new version'
      property :created_at,
               type: :string,
               format: :'date-time',
               description: 'When the version was created'
      property :actor,
               type: :string,
               description: 'Who performed the changes'
      property :url,
               type: :string,
               description: 'Version URL'
    end

    swagger_schema :ValidationError do
      property :errors,
               description: 'List of validation error messages',
               type: :array,
               items: { type: :string }
      property :json_schema,
               description: 'List of json-schema\'s used for validation',
               type: :array,
               items: { type: :string, description: 'json-schema URL' }
    end

    swagger_schema :DeleteToken do
      key :description, 'Marks an envelope as deleted'
      property :delete_token,
               type: :string,
               required: true,
               description: 'Any content signed with the user\'s private key'
      property :delete_token_format,
               type: :string,
               required: true,
               description: 'Format of the submitted delete token'
      property :delete_token_encoding,
               type: :string,
               required: true,
               description: 'Encoding of the submitted delete token'
      property :delete_token_public_key,
               type: :string,
               required: true,
               description: 'RSA key in PEM format (same pair used to encode)'
    end

    swagger_schema :PostRequestEnvelope do
      key :description, 'Publishes a new envelope'

      property :envelope_id,
               type: :string,
               description: 'Unique identifier (in UUID format)'
      property :envelope_type,
               type: :string,
               required: true,
               description: 'Type ("resource_data" or "paradata")'
      property :envelope_version,
               type: :string,
               required: true,
               description: 'Envelope version used'
      property :resource,
               type: 'string',
               required: true,
               description: 'Resource in its original encoded format'
      property :resource_format,
               type: 'string',
               required: true,
               description: 'Format of the submitted resource'
      property :resource_encoding,
               type: 'string',
               description: 'Encoding of the submitted resource'
      property :resource_public_key,
               type: :string,
               required: true,
               description: 'RSA key in PEM format (same pair used to encode)'
    end

    # ==========================================
    # Root Info

    swagger_root do
      key :swagger, '2.0'
      info do
        key :title, 'MetadataRegistry API'
        key :description, 'Documentation for the new API endpoints'
        key :version, 'v1'

        contact name: 'Metadata Registry',
                email: 'learningreg-dev@googlegroups.com',
                url: 'https://github.com/learningtapestry/metadataregistry'

        license name: 'Apache License, Version 2.0',
                url: 'http://www.apache.org/licenses/LICENSE-2.0'
      end
      key :host, 'localhost:9292' # 'lr-staging.learningtapestry.com'
      key :consumes, ['application/json']
      key :produces, ['application/json']
    end
  end
end
