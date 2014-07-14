package models

import (

	"github.com/koding/bongo"
)

func (m MessageReply) GetId() int64 {
	return m.Id
}

func (m MessageReply) TableName() string {
	return "api.message_reply"
}

func NewMessageReply() *MessageReply {
	return &MessageReply{}
}

func (m *MessageReply) BeforeCreate() error {
	return m.MarkIfExempt()
}

func (m *MessageReply) BeforeUpdate() error {
	return m.MarkIfExempt()
}

func (m *MessageReply) AfterCreate() {
	bongo.B.AfterCreate(m)
}

func (m *MessageReply) AfterUpdate() {
	bongo.B.AfterUpdate(m)
}

func (m MessageReply) AfterDelete() {
	bongo.B.AfterDelete(m)
}

func (m *MessageReply) ById(id int64) error {
	return bongo.B.ById(m, id)
}

func (m *MessageReply) Create() error {
	return bongo.B.Create(m)
}

func (m *MessageReply) Update() error {
	return bongo.B.Update(m)
}

func (m *MessageReply) Some(data interface{}, q *bongo.Query) error {
	return bongo.B.Some(m, data, q)
}

func (m *MessageReply) One(q *bongo.Query) error {
	return bongo.B.One(m, m, q)
}