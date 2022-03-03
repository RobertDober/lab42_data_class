# frozen_string_literal: true

module Kernel
  Constraint = Lab42::DataClass::Constraint
  Maker = Lab42::DataClass::Proxy::Constraints::Maker # TODO: Move Maker to Lab42::DataClass:ConstraintMaker
  Anything = Constraint.new(name: "Anything", function: ->(_) { true })
  Boolean = Constraint.new(name: "Boolean", function: -> { [false, true].member?(_1) })

  def All?(constraint = nil, &blk)
    constraint = Maker.make_constraint(constraint, &blk)
    f = -> do
      _1.all?(&constraint)
    end
    Constraint.new(name: "All?(#{constraint})", function: f)
  end

  def Any?(constraint = nil, &blk)
    constraint = Maker.make_constraint(constraint, &blk)
    f = -> do
      _1.any?(&constraint)
    end
    Constraint.new(name: "Any?(#{constraint})", function: f)
  end

  def Choice(*constraints)
    constraints = constraints.map{ Maker.make_constraint _1 }
    f = ->(value) do
      constraints.any?{ _1.(value) }
    end
    Constraint.new(name: "Choice(#{constraints.join(', ')})", function: f)
  end

  def Contains(str)
    f = -> { _1.include?(str) rescue false }
    Constraint.new(name: "Contains(#{str})", function: f)
  end

  def EndsWith(str)
    f = -> { _1.end_with?(str) rescue false }
    Constraint.new(name: "EndsWith(#{str})", function: f)
  end

  def Lambda(arity)
    f = -> do
      _1.arity == arity rescue false
    end
    Constraint.new(name: "Lambda(#{arity})", function: f)
  end

  def NilOr(constraint = nil, &blk)
    constraint = Maker.make_constraint(constraint, &blk)
    f = -> { _1.nil? || constraint.(_1) }
    Constraint.new(name: "NilOr(#{constraint})", function: f)
  end

  def Not(constraint = nil, &blk)
    constraint = Maker.make_constraint(constraint, &blk)
    f = -> { !constraint.(_1) }
    Constraint.new(name: "Not(#{constraint})", function: f)
  end

  def PairOf(fst, snd)
    fst_constraint = Maker.make_constraint(fst)
    snd_constraint = Maker.make_constraint(snd)
    f = -> do
      Lab42::Pair === _1 && fst_constraint.(_1.first) && snd_constraint.(_1.second)
    end
    Constraint.new(name: "PairOf(#{fst_constraint}, #{snd_constraint})", function: f)
  end

  def StartsWith(str)
    f = -> { _1.start_with?(str) rescue false }
    Constraint.new(name: "StartsWith(#{str})", function: f)
  end

  def TripleOf(fst, snd, trd)
    fst_constraint = Maker.make_constraint(fst)
    snd_constraint = Maker.make_constraint(snd)
    trd_constraint = Maker.make_constraint(trd)
    f = -> do
      Lab42::Triple === _1 && fst_constraint.(_1.first) && snd_constraint.(_1.second) && trd_constraint.(_1.third)
    end
    Constraint.new(name: "TripleOf(#{fst_constraint}, #{snd_constraint}, #{trd_constraint})", function: f)
  end
end
# SPDX-License-Identifier: Apache-2.0
