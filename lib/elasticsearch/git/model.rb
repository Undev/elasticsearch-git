require 'active_support/concern'
require 'active_model'
require 'elasticsearch/model'

module Elasticsearch
  module Git
    module Model
      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Naming
        include ActiveModel::Model
        include Elasticsearch::Model

        env = if defined?(::Rails)
                ::Rails.env.to_s
              else
                "undefined"
              end

        index_name [self.name.downcase, 'index', env].join('-')

        settings \
          index: {
          analysis: {
            analyzer: {
              human_analyzer: {
                type: 'custom',
                tokenizer: 'human_tokenizer',
                filter: %w(lowercase asciifolding)
              },
              path_analyzer: {
                type: 'custom',
                tokenizer: 'path_tokenizer',
                filter: %w(lowercase asciifolding)
              },
              sha_analyzer: {
                type: 'custom',
                tokenizer: 'sha_tokenizer',
                filter: %w(lowercase asciifolding)
              },
              code_analyzer: {
                type: 'custom',
                tokenizer: 'standard',
                filter: %w(lowercase asciifolding code_stemmer)
              }
            },
            tokenizer: {
              sha_tokenizer: {
                type: "edgeNGram",
                min_gram: 8,
                max_gram: 40,
                token_chars: %w(letter digit)
              },
              human_tokenizer: {
                type: "NGram",
                min_gram: 1,
                max_gram: 20,
                token_chars: %w(letter digit)
              },
              path_tokenizer: {
                type: 'path_hierarchy',
                reverse: true
              },
            },
            filter: {
              code_stemmer: {
                type: "stemmer",
                name: "minimal_english"
              }
            }
          }
        }
      end
    end
  end
end
