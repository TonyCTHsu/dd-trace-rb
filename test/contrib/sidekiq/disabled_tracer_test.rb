
require 'contrib/sidekiq/tracer_test_base'

class DisabledTracerTest < TracerTestBase
  class EmptyWorker
    include Sidekiq::Worker

    def perform; end
  end

  def setup
    super

    Sidekiq::Testing.server_middleware do |chain|
      chain.add(Datadog::Contrib::Sidekiq::Tracer,
                tracer: @tracer, enabled: false)
    end
  end

  def test_empty
    EmptyWorker.perform_async()

    spans = @writer.spans()
    assert_equal(0, spans.length)
  end
end
