require_relative '../setup'

describe Worker::Base do
  it 'should validate args' do
    TestWorker = Class.new(Worker::Base) do
      def perform(args)
        validate_args(args, -> (args) { Hash === args }, 'must be an Hash')
        validate_args(args, -> (args) { args.key?('random_id') }, 'must contains `random_id`')
        'nothing'
      end
    end

    TestWorker.new.perform({ 'random_id' => 1 })
  end
end