require '../test_framework'

def log(msg)
  # puts msg
end

class Adv9_a < TestFramework
  def logic(t)
    score = 0
    in_group = 0
    in_garbage = false
    skip = false
    t.chars.each do |c|
      if skip
        log "chars #{c}, ! - skipping"
        skip = false
        next
      end
      if in_garbage && (c != '>') && c != '!'
        log "chars #{c}, garbage - skipping"
        next
      end
      # noinspection RubyCaseWithoutElseBlockInspection
      case c
        when '{'
          in_group += 1
          score += in_group
          log "chars #{c}, in group #{in_group} score up #{score}"
        when '}'
          in_group -= 1
          log "chars #{c}, in group #{in_group}"
        when '<'
          in_garbage = true
          log "chars #{c}, garbage on"
        when '>'
          in_garbage = false
          log "chars #{c}, garbage off"
        when '!'
          skip = true
      end
    end
    score
  end
end

class Adv9_b < TestFramework
  def logic(t)
    score = 0
    in_garbage = false
    skip = false
    t.chars.each do |c|
      if skip
        log "chars #{c}, ! - skipping"
        skip = false
        next
      end
      if in_garbage && (c != '>') && c != '!'
        log "chars #{c}, garbage - skipping"
        score += 1
        next
      end
      # noinspection RubyCaseWithoutElseBlockInspection
      case c
        when '<'
          in_garbage = true
          log "chars #{c}, garbage on"
        when '>'
          in_garbage = false
          log "chars #{c}, garbage off"
        when '!'
          skip = true
      end
    end
    score
  end
end

adva = Adv9_a.new({
                      '{}' => 1,
                      '{{{}}}' => 6,
                      '{{},{}}' => 5,
                      '{{{},{},{{}}}}' => 16,
                      '{<a>,<a>,<a>,<a>}' => 1,
                      '{{<ab>},{<ab>},{<ab>},{<ab>}}' => 9,
                      '{{<!!>},{<!!>},{<!!>},{<!!>}}' => 9,
                      '{{<a!>},{<a!>},{<a!>},{<ab>}}' => 3
                  }, 9)
# adva.test
# puts adva.run

advb = Adv9_b.new({
                      '<>' => 0,
                      '<random characters>' => 17,
                      '<<<<>' => 3,
                      '<{!>}>' => 2,
                      '<!!>' => 0,
                      '<!!!>>' => 0,
                      '<{o"i!a,<{i<a>' => 10
                  }, 9)
advb.test
puts advb.run
