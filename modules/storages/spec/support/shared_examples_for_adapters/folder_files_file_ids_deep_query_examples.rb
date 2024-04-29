# frozen_string_literal: true

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2024 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

RSpec.shared_examples_for "folder_files_file_ids_deep_query: basic query setup" do
  it "is registered as queries.folder_files_file_ids_deep" do
    expect(Storages::Peripherals::Registry
             .resolve("#{storage.short_provider_type}.queries.folder_files_file_ids_deep")).to eq(described_class)
  end

  it "responds to #call with correct parameters" do
    expect(described_class).to respond_to(:call)

    method = described_class.method(:call)
    expect(method.parameters).to contain_exactly(%i[keyreq storage],
                                                 %i[keyreq auth_strategy],
                                                 %i[keyreq folder])
  end
end

RSpec.shared_examples_for "folder_files_file_ids_deep_query: successful query" do
  it "returns a map of locations to file ids" do
    result = described_class.call(storage:, auth_strategy:, folder:)

    expect(result).to be_success

    response = result.result
    expect(response.transform_values(&:id)).to eq(expected_ids)
  end
end

RSpec.shared_examples_for "folder_files_file_ids_deep_query: not found" do
  it "returns a failure" do
    result = described_class.call(storage:, auth_strategy:, folder:)

    expect(result).to be_failure

    error = result.errors
    expect(error.code).to eq(:not_found)
    expect(error.data.source).to eq(error_source)
  end
end
