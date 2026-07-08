# app/models の注意点

- Ticket の belongs_to :user, optional: true はバグではない。退会（User#destroy）時に dependent: :nullify で tickets.user_id / events.owner_id を NULL 化し、ビューが「退会したユーザです」と表示する設計。required に「修正」すると退会が壊れる
