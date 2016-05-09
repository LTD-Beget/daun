require 'spec_helper'
require 'daun/cli'
require 'fileutils'
require 'tmpdir'

describe 'daun' do

  let(:tmpdir) { Dir.mktmpdir }
  let(:bare_repository) { BareTestRepository.new(File.join(tmpdir, 'bare-repository')) }
  let(:destination) { File.join(tmpdir, 'repository') }

  after(:each) do
    FileUtils.rm_rf(tmpdir)
  end

  it "checks out master branch successfully" do
    bare_repository.write_file "foo.txt", "branch/master"

    Daun::CLI.start %W{ init #{bare_repository.path} #{destination}}
    Daun::CLI.start %W{ checkout --directory #{destination} }

    expect(File).to exist("#{destination}/branches/master")
    expect(File).to exist("#{destination}/branches/master/foo.txt")
    expect(File.read("#{destination}/branches/master/foo.txt")).to match "branch/master"
  end

  it 'checks out other branch successfully' do
    bare_repository.create_branch 'other'
    bare_repository.write_file "foo.txt", "branch/other"

    Daun::CLI.start %W{ init #{bare_repository.path} #{destination}}
    Daun::CLI.start %W{ checkout --directory #{destination} }

    expect(File).to exist("#{destination}/branches/other")
    expect(File).to exist("#{destination}/branches/other/foo.txt")
    expect(File.read("#{destination}/branches/other/foo.txt")).to match "branch/other"
  end

  it 'checks out lightweight tags' do
    bare_repository.write_file "foo.txt", "tag/lightweight"
    bare_repository.create_lightweight_tag 'lightweight'

    Daun::CLI.start %W{ init #{bare_repository.path} #{destination}}
    Daun::CLI.start %W{ checkout --directory #{destination} }

    expect(File).to exist("#{destination}/tags/lightweight")
    expect(File).to exist("#{destination}/tags/lightweight/foo.txt")
    expect(File.read("#{destination}/tags/lightweight/foo.txt")).to match "tag/lightweight"
  end

  it 'checks out annotated tags' do
    bare_repository.write_file "foo.txt", "tag/annotated"
    bare_repository.create_annotated_tag 'annotated'

    Daun::CLI.start %W{ init #{bare_repository.path} #{destination}}
    Daun::CLI.start %W{ checkout --directory #{destination} }

    expect(File).to exist("#{destination}/tags/annotated")
    expect(File).to exist("#{destination}/tags/annotated/foo.txt")
    expect(File.read("#{destination}/tags/annotated/foo.txt")).to match "tag/annotated"
  end
end
