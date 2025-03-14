// TODO: What dose an invite mean here?
// Would it just pre-associate something in order to directly assign the "user to be created" into a specific team or give a scope?
// Or would one want to use this to lock down all sign-ups and only allow internal registrations? (e.g. that no attacker could just use the generated registration endpoints themselves)

// Maybe an invite would just be part of the email provider for starters?

// Or how would we allow an invitee to accept the invite via any e-mail they want to use?

// maybe the invite is just a mail being sent out, and then the client can send the invite code and that would somehow run a `Future` call that modifies the newly
// created user object in the desired manner?
// Though then this might not be a specific authentication method and could be built externally.

// or maybe such a system should indeed create the user-object already (and then e.g. add it to a team), and the invite part would just take care of saying: Hey, instead of creating a new user, attach them here 
// (in that case it'd be important to use the invite ID instead of the email to allow the switch (or just subtle change) described above)