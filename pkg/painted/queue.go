package painted

import "github.com/gammazero/deque"

type NotifQueue struct {
	queue deque.Deque[*Notification]
	index int
}

func (n *NotifQueue) Get() *Notification {
	if n.index+1 <= n.queue.Len() {
		return n.queue.At(n.index)
	} else {
		return nil
	}
}

func (n *NotifQueue) Remove() *Notification {
	if n.queue.Len() > 0 {
		return n.queue.PopFront()
	} else {
		return nil
	}
}

func (n *NotifQueue) Next() {
	if n.index > 0 {
		n.index -= 1
	}
}

func (n *NotifQueue) Prev() {
	if n.index+1 < n.queue.Len() {
		n.index += 1
	}
}

func (n *NotifQueue) Push(x *Notification) {
	n.index = 0
	n.queue.PushFront(x)
}

func (n *NotifQueue) CallOnCurrent(callback func(*Notification)) {
	if n.queue.Len() > 0 {
		x := n.queue.At(n.index)
		callback(x)
	}
}
