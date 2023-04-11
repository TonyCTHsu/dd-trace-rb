# frozen_string_literal: true

module Datadog
  module AppSec
    module Contrib
      module Sinatra
        # Sinatra integration constants
        module Ext
          APP = 'sinatra'
          ENV_ENABLED = 'DD_TRACE_SINATRA_ENABLED'
          ROUTE_INTERRUPT = :datadog_appsec_contrib_sinatra_route_interrupt
        end
      end
    end
  end
end
