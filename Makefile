

install:        
	git archive --format=tar HEAD > ~/HEAD.tar && cd && tar xf HEAD.tar && rm HEAD.tar

update_install:        
	git pull && make install

