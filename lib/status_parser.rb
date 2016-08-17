class Status
  require 'date'

  def initialize(output)
    status_command = output.match(/<.+/m).to_s
    doc = Nokogiri::XML(status_command,nil,'iso8859-1')

    @status_result = [
      doc.xpath('//info/max').text.to_i,
      doc.xpath('//info/capacity_used').text.to_i,
      doc.xpath('//info/get_wait_list_size').text.to_i,
      parse_sessions(doc),
      parse_cpu(doc),
      parse_app_memory(doc),
      parse_last_used(doc),
      parse_uptime(doc),
      parse_processed(doc)
    ]
  end

  def max
    @status_result[0]
  end

  def current
    @status_result[1]
  end

  def queue
    @status_result[2]
  end

  def sessions
    @status_result[3]
  end

  def cpu
    @status_result[4]
  end

  def process_memory
    @status_result[5]
  end

  def last_used_time
    @status_result[6]
  end

  def uptime
    @status_result[7]
  end

  def processed
    @status_result[8]
  end

  private

  def name_clean(app_name)
    if app_name.length > 45
      first_half = app_name.match('.+:').to_s
      second_half = app_name.split('/')[-1].to_s
      cleaned_name = first_half + ' ' + second_half
    else
      cleaned_name = app_name
    end
    cleaned_name
  end

  def parse_sessions(doc)
    sessions_ea = Hash.new(0)
    doc.xpath('//process').each do |x|
      sessions_ea[x.xpath('./pid').text + x.xpath('./command').text.partition(':').last] = x.xpath('./sessions').text.to_i
    end
    sessions_ea
  end

  def parse_cpu(doc)
    cpu_util = Hash.new(0)
    doc.xpath('//process').each do |x|
      cpu_util[x.xpath('./pid').text + x.xpath('./command').text.partition(':').last] = x.xpath('./cpu').text.to_i
    end
    cpu_util
  end

  def parse_app_memory(doc)
    processes = Hash.new(0)
    doc.xpath('//process').each do |x|
      processes[x.xpath('./pid').text + x.xpath('./command').text.partition(':').last] = (x.xpath('./real_memory').text.to_i / 1000)
    end
    processes
  end

  def parse_last_used(doc)
    processes = Hash.new(0)
    doc.xpath('//process').each do |x|
      unix_stamp = (x.xpath('./last_used').text.to_i / 1000000)
      elapsed = Time.now.to_i - unix_stamp
      processes[x.xpath('./pid').text + x.xpath('./command').text.partition(':').last] = elapsed
    end
    processes
  end

  def parse_uptime(doc)
    processes = Hash.new(0)
    doc.xpath('//process').each do |x|
      unix_stamp = (x.xpath('./spawn_end_time').text.to_i / 1000000)
      elapsed = Time.now.to_i - unix_stamp
      processes[x.xpath('./pid').text + x.xpath('./command').text.partition(':').last] = elapsed
    end
    processes
  end

  def parse_processed(doc)
    processes = Hash.new(0)
    doc.xpath('//process').each do |x|
      processes[x.xpath('./pid').text + x.xpath('./command').text.partition(':').last] = x.xpath('./processed').text.to_i
    end
    processes
  end

end
