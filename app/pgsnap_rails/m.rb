class M
  # eg reload!; M.it { Drills.new.aggregates }
  def self.it
    # <Warmup>
    yield
    yield
    yield
    # </Warmup>
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    puts "#{(finish - start) * 1000} ms"
    true
  end
end
