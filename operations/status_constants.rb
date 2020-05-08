# frozen_string_literal: true

class Status
  UNLEARNED       = 'not learned'
  IN_LEARNING_LV1 = 'in learning, level 1'
  IN_LEARNING_LV2 = 'in learning, level 2'
  IN_LEARNING_LV3 = 'in learning, level 3'
  LEARNED         = 'learned'

  def get_status
    [UNLEARNED, IN_LEARNING_LV1, IN_LEARNING_LV2, IN_LEARNING_LV3, LEARNED]
  end
end
