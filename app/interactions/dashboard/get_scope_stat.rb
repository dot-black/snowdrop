require 'active_interaction'

class GetScopeStat < ActiveInteraction::Base
  array :scopes
  interface :model
  symbol :scope_for_total, default: :all

  def execute
    _set_empty_result
    _find_total_count
    _find_count_for_each_scope
    _find_percentage_for_each_scope
    _save_to_results_for_each_scope
    @result
  end

  private

  def _set_empty_result
    @result = { count: {}, percentage: {} }
  end

  def _find_total_count
    @total_count = model.public_send(scope_for_total).count
    @result[:count][:total] = @total_count
  end

  def _find_count_for_each_scope
    @scope_count = {}
    scopes.each { |scope| @scope_count[scope] = model.public_send(scope).count }
  end

  def _find_percentage_for_each_scope
    @scope_percentage = {}
    scopes.each do |scope|
      @scope_percentage[scope] =
        if @total_count.positive?
          @scope_count[scope].to_f / @total_count.to_f * 100.0
        else
          0
        end
    end
  end

  def _save_to_results_for_each_scope
    scopes.each do |scope|
      @result[:count][scope] = @scope_count[scope]
      @result[:percentage][scope] = @scope_percentage[scope]
    end
  end
end
