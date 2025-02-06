# frozen_string_literal: true

require 'json'
require_relative '../../../instrumentation/gateway'

module Datadog
  module AppSec
    module Contrib
      module GraphQL
        module Gateway
          # Watcher for Rack gateway events
          module Watcher
            class << self
              def watch
                gateway = Instrumentation.gateway

                watch_multiplex(gateway)
              end

              def watch_multiplex(gateway = Instrumentation.gateway)
                gateway.watch('graphql.multiplex', :appsec) do |stack, gateway_multiplex|
                  context = AppSec::Context.active

                  if context
                    persistent_data = {
                      'graphql.server.all_resolvers' => gateway_multiplex.arguments
                    }

                    result = context.run_waf(persistent_data, {}, Datadog.configuration.appsec.waf_timeout)

                    if result.match?
                      Datadog::AppSec::Event.tag_and_keep!(context, result)

                      context.events << {
                        waf_result: result,
                        trace: context.trace,
                        span: context.span,
                        multiplex: gateway_multiplex,
                        actions: result.actions
                      }

                      Datadog::AppSec::ActionsHandler.handle(result.actions)
                    end
                  end

                  stack.call(gateway_multiplex.arguments)
                end
              end
            end
          end
        end
      end
    end
  end
end
