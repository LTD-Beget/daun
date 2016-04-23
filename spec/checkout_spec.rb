require 'spec_helper'
require 'git-opengrok/checkout'
require 'tmpdir'
require 'git'
require 'fileutils'

describe 'checkout' do
  it 'checks out master branch' do
    Dir.mktmpdir do |dir|
      # Preparation
      bare_repository = File.join(dir, 'bare-repository')
      Git.init(bare_repository, :bare => true)
      working_tree_path = File.join(dir, 'working_tree')
      working_tree_repo = Git.clone(bare_repository, working_tree_path)
      FileUtils.cp_r 'spec/repo/.', working_tree_path
      working_tree_repo.add(:all => true)
      working_tree_repo.commit('Add repo')
      working_tree_repo.push

      # Execute
      destination = File.join(dir, 'repository')
      checkout = GitOpenGrok::Checkout.new(destination, bare_repository)
      checkout.apply

      # Verification
      expect(File).to exist("#{destination}/branches/master")
      expect(File).to exist("#{destination}/branches/master/foo.txt")
    end
  end

  it 'checks out other branches'
  it 'checks out tags'
  it 'deletes branch which have been deleted in remote'
  it 'deletes tag which have been deleted in remote'
  it 'adds new branch which have been added after the first checkout'
  it 'does not check out anything other than the branches and tags to avoid clutter'
end
