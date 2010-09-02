class BatchLockException < Exception; end
module BatchLock
  # Lock and do something
  def self.run(batch_name)
    FileUtils.mkdir(RAILS_ROOT + '/tmp/batch_lock') unless File.exists?(RAILS_ROOT + '/tmp/batch_lock')
    # Locking as batch_name, you can't run same batch_name at the same time
    File.open("#{RAILS_ROOT}/tmp/batch_lock/#{batch_name}", 'w') do |f|
      if f.flock(File::LOCK_EX | File::LOCK_NB)
        yield
      else
        raise BatchLockException.new
      end
    end
  end
 
  # is batch_name running?
  def self.running?(batch_name)
    FileUtils.mkdir(RAILS_ROOT + '/tmp/batch_lock') unless File.exists?(RAILS_ROOT + '/tmp/batch_lock')
    File.open("#{RAILS_ROOT}/tmp/batch_lock/#{batch_name}", 'w') do |f|
      ! f.flock(File::LOCK_EX | File::LOCK_NB)
    end
  end
end
