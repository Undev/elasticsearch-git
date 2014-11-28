module Elasticsearch
  module Git
    module Utils
      extend self

      def parse_revs(repository_for_indexing, from_rev, to_rev)
        from = if index_new_branch?(from_rev)
                 if to_rev == repository_for_indexing.last_commit.oid
                   nil
                 else
                   merge_base(to_rev, repository_for_indexing)
                 end
               else
                 from_rev
               end

        return from, to_rev
      end

      def index_new_branch?(from)
        from == '0000000000000000000000000000000000000000'
      end

      def merge_base(to_rev, repository_for_indexing)
        head_sha = repository_for_indexing.last_commit.oid
        repository_for_indexing.merge_base(to_rev, head_sha)
      end
    end
  end
end
