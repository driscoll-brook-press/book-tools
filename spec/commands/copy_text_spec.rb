$LOAD_PATH.unshift '../lib'

require 'copy_text'

require_relative '../spec_helper'

require 'strscan'

describe CopyText do
  subject { CopyText.new pattern }
  let(:translator) { FakeTranslator.new }
  let(:output) { StringIO.new }
  let(:scanner) { StringScanner.new input }

  describe 'when input begins with a match for the copy pattern' do
    let(:input) { 'stuff1234,.!:' }
    let(:pattern) { /[[:alnum:]]*/ }

    it 'writes the matching text' do
      subject.execute translator, scanner, output

      output.string.must_equal 'stuff1234'
    end

    it 'consumes the matching text' do
      subject.execute translator, scanner, output

      scanner.rest.must_equal ',.!:'
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command' do
        translator.expect :read_command, nil

        subject.execute translator, scanner, output
      end
    end
  end

  describe 'when input begins with a mismatch for the copy pattern' do
    let(:input) { 'A bunch of text with no punctuation' }
    let(:output) { StringIO.new previous_output }
    let(:pattern) { /[[:punct:]]/ }
    let(:previous_output) { 'previous output' }

    it 'writes no output' do
      subject.execute translator, scanner, output

      output.string.must_equal previous_output
    end

    it 'consumes no input' do
      subject.execute translator, scanner, output

      scanner.rest.must_equal input
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command' do
        translator.expect :read_command, nil

        subject.execute translator, scanner, output
      end
    end
  end
end
