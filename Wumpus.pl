
:- use_module(library(random)).
:- use_module(library(tabular)).
:- use_module(library(autowin)).

:- dynamic([
       /*******CARTE DE JEU*******/
       joueur/1,
       mur/1,
       monstre/1,
       tresor/1,
       ascenseur/1,
       trou/1,
       souffle/1,
       odeur/1,
       bruit/1,
       bling/1,
       /*********PERCEPTS********/
       maybeAscenseur/1,
       maybeMonstre/1,
       maybeTrou/1,
       maybeTresor/1,
       sureAscenseur/1,
       ascenseurTrouve/0,
       sureMonstre/1,
       sureTrou/1,
       sureTresor/1,
       tresorTrouve/0,
       sureNotAscenseur/1,
       sureNotMonstre/1,
       sureNotTrou/1,
       sureNotTresor/1,
       visite/1,
       safe/1,
       /*****DONNEES DE JEU******/
       direction/1,		  % 1=Nord; 2=Est; 3=Sud; 4=Ouest;
       fleche/0,
       gagner/0,
       perdu/0
   ]).

start :-
	new(P, picture('Wumpus World', size(725,550))),
	start(P).

start(P) :-
	initialise,
	afficherJeu(P),
	sleep(1),
	boucleDeJeu(P).

/*******************************************/
/**************INITIALISATION***************/
/*******************************************/

initialise :-
	initialisation,
	initialiserJoueur,
	initialiserMur,
	initialiserMonstre,
	initialiserTresor,
	initialiserAscenseur,
	initialiserTrous(3),
	miseAJourPredicat.

initialisation :-
	retractall(joueur([_,_])),
	retractall(mur([_,_])),
	retractall(monstre([_,_])),
	retractall(trou([_,_])),
	retractall(souffle([_,_])),
	retractall(bling([_,_])),
	retractall(tresor([_,_])),
	retractall(ascenseur([_,_])),
	retractall(bruit([_,_])),
	retractall(odeur([_,_])),
	retractall(maybeAscenseur([_,_])),
	retractall(maybeMonstre([_,_])),
	retractall(maybeTrou([_,_])),
	retractall(maybeTresor([_,_])),
	retractall(sureAscenseur([_,_])),
	retractall(sureMonstre([_,_])),
	retractall(sureTrou([_,_])),
	retractall(sureTresor([_,_])),
	retractall(sureNotAscenseur([_,_])),
	retractall(sureNotTresor([_,_])),
	retractall(sureNotMonstre([_,_])),
	retractall(sureNotTrou([_,_])),
	retractall(visite([_,_])),
	retractall(safe([_,_])),
	retractall(direction(_)),
	retractall(tresorTrouve),
	retractall(ascenseurTrouve),
	retractall(gagner),
	retractall(perdu),
	assert(fleche),
	assert(direction(2)),
	!.

initialiserJoueur :-
	assert(joueur([1,1])).

initialiserMur :-
	assert(mur([0,0])),
	assert(mur([0,1])),
	assert(mur([0,2])),
	assert(mur([0,3])),
	assert(mur([0,4])),
	assert(mur([0,5])),
	assert(mur([1,5])),
	assert(mur([2,5])),
	assert(mur([3,5])),
	assert(mur([4,5])),
	assert(mur([5,5])),
	assert(mur([5,4])),
	assert(mur([5,3])),
	assert(mur([5,2])),
	assert(mur([5,1])),
	assert(mur([5,0])),
	assert(mur([4,0])),
	assert(mur([3,0])),
	assert(mur([2,0])),
	assert(mur([1,0])),
	!.

initialiserMonstre :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    assert(monstre([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    assert(odeur([X,Ym])),
	    assert(odeur([X,Yp])),
	    assert(odeur([Xm,Y])),
	    assert(odeur([Xp,Y]))

	);
	initialiserMonstre,
	!.

initialiserTresor :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    assert(tresor([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    assert(bling([X,Ym])),
	    assert(bling([X,Yp])),
	    assert(bling([Xm,Y])),
	    assert(bling([Xp,Y]))

	);
	initialiserTresor,
	!.

initialiserAscenseur :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    assert(ascenseur([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    assert(bruit([X,Ym])),
	    assert(bruit([X,Yp])),
	    assert(bruit([Xm,Y])),
	    assert(bruit([Xp,Y]))
	);
	initialiserAscenseur,
	!.

initialiserTrous(Nb) :-
	assignerTrous(Nb),
	!.

assignerTrous(Nb) :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    (
		X>2;
		Y>2
	    ),
	    assert(trou([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    assert(souffle([X,Ym])),
	    assert(souffle([X,Yp])),
	    assert(souffle([Xm,Y])),
	    assert(souffle([Xp,Y])),
	    Nbb is Nb - 1,
	    (
			    Nbb =< 0;
			    assignerTrous(Nbb)
	    )
	);
	assignerTrous(Nb),
	!.

/*******************************************/
/****************PREDICAT*******************/
/*******************************************/


miseAJourPredicat :-
	getJoueur(X,Y,1,1),
	assert(visite([X,Y])),
	retractall(safe([X,Y])),
	(
	    (
	        not(not(monstre([X,Y]))),
	        assert(sureMonstre([X,Y]))
	    );
	(
	        not(monstre([X,Y])),
	        assert(sureNotMonstre([X,Y]))
	    )
	),
	(
	    (
	        not(not(tresor([X,Y]))),
	        assert(sureTresor([X,Y])),
	        assert(tresorTrouve)
	    );
	(
	        not(tresor([X,Y])),
	        assert(sureNotTresor([X,Y]))
	    )
	),
	(
	    (
	        not(not(ascenseur([X,Y]))),
	        assert(sureAscenseur([X,Y])),
	        assert(ascenseurTrouve)
	    );
	(
	        not(ascenseur([X,Y])),
	        assert(sureNotAscenseur([X,Y]))
	    )
	),
	(
	    (
	        not(not(trou([X,Y]))),
	        assert(sureTrou([X,Y]))
	    );
	(
	        not(trou([X,Y])),
	        assert(sureNotTrou([X,Y]))
	    )
	),
	(   (
	    not(souffle([X,Y])),
	    not(odeur([X,Y])),
	    ((Xa is X,Ya is Y + 1, not(mur([Xa,Ya])),not(visite([Xa,Ya])), assert(safe([Xa,Ya])));!),
	    ((Xb is X,Yb is Y - 1, not(mur([Xb,Yb])),not(visite([Xb,Yb])), assert(safe([Xb,Yb])));!),
	    ((Xc is X + 1,Yc is Y, not(mur([Xc,Yc])),not(visite([Xc,Yc])), assert(safe([Xc,Yc])));!),
	    ((Xd is X - 1,Yd is Y, not(mur([Xd,Yd])),not(visite([Xd,Yd])), assert(safe([Xd,Yd])));!)
	);!),
	((
	    not(not(odeur([X,Y]))),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    not(sureMonstre([Xup,Y])),
	    not(sureMonstre([Xdown,Y])),
	    not(sureMonstre([X,Yup])),
	    not(sureMonstre([X,Ydown])),
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotMonstre([Xup,Y]))) ;
		    assert(maybeMonstre([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotMonstre([Xdown,Y]))) ;
		    assert(maybeMonstre([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotMonstre([X,Yup]))) ;
		    assert(maybeMonstre([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotMonstre([X,Ydown]))) ;
		    assert(maybeMonstre([X,Ydown]))
		)
	    );!)
	);
	(
	    not(odeur([X,Y])),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotMonstre([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotMonstre([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotMonstre([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotMonstre([X,Ydown]))
		)
	    );!)
	);!),
	(   (
	    not(not(souffle([X,Y]))),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotTrou([Xup,Y]))) ;
		    assert(maybeTrou([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotTrou([Xdown,Y]))) ;
		    assert(maybeTrou([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotTrou([X,Yup]))) ;
		    assert(maybeTrou([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotTrou([X,Ydown]))) ;
		    assert(maybeTrou([X,Ydown]))
		)
	    );!)
	);
	(
	    not(souffle([X,Y])),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotTrou([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotTrou([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotTrou([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotTrou([X,Ydown]))
		)
	    );!)
	);!),

	(   (
	    not(not(bruit([X,Y]))),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    not(sureAscenseur([Xup,Y])),
	    not(sureAscenseur([Xdown,Y])),
	    not(sureAscenseur([X,Yup])),
	    not(sureAscenseur([X,Ydown])),
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotAscenseur([Xup,Y]))) ;
		    assert(maybeAscenseur([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotAscenseur([Xdown,Y]))) ;
		    assert(maybeAscenseur([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotAscenseur([X,Yup]))) ;
		    assert(maybeAscenseur([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotAscenseur([X,Ydown]))) ;
		    assert(maybeAscenseur([X,Ydown]))
		)
	    );!)
	);
	(
	    not(bruit([X,Y])),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotAscenseur([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotAscenseur([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotAscenseur([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotAscenseur([X,Ydown]))
		)
	    );!)
	);!),


	(   (
	    not(not(bling([X,Y]))),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    not(sureTresor([Xup,Y])),
	    not(sureTresor([Xdown,Y])),
	    not(sureTresor([X,Yup])),
	    not(sureTresor([X,Ydown])),
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotTresor([Xup,Y]))) ;
		    assert(maybeTresor([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotTresor([Xdown,Y]))) ;
		    assert(maybeTresor([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotTresor([X,Yup]))) ;
		    assert(maybeTresor([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotTresor([X,Ydown]))) ;
		    assert(maybeTresor([X,Ydown]))
		)
	    );!)
	);
	(
	    not(bling([X,Y])),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotTresor([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotTresor([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotTresor([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotTresor([X,Ydown]))
		)
	    );!)
	);!),

	miseAJourPredicatsMonde,
	!.

miseAJourPredicatsMonde :-
	miseAJourPredicatsCase(0,0),
	!.

miseAJourPredicatsCase(Xa,Ya) :-
	(
	     (
		 (Xa < 6, Xb is Xa, Yb is Ya);
		 (Xa > 5, Xb is 0, Yb is Ya + 1)
	     ),

             (
		   (
		         Ya > 5
	           );
	           (
	                 (
		              ((sureNotMonstre([Xb,Yb]),sureNotTrou([Xb,Yb]),not(visite([Xb,Yb])), not(mur([Xb,Yb])),assert(safe([Xb,Yb])));!),
		              Xc is Xb + 1,
	                      miseAJourPredicatsCase(Xc,Yb)
		         )
		   )
	     )
	),
	!.

/*******************************************/
/**************BOUCLE DE JEU****************/
/*******************************************/

boucleDeJeu(P) :-
	(
            etapeSuivante,
            verifierEtatJeu,
            afficherJeu(P),
            sleep(1),
            (
		(
		    (not(not(gagner));not(not(perdu))),
		    start(P)
		);
		boucleDeJeu(P)
	    )
	),
	!.

verifierEtatJeu :-
	    getJoueur(X,Y,1,1),
	    ((not(not(ascenseur([X,Y]))),not(not(tresorTrouve)),assert(gagner));!),
	    (((not(not(monstre([X,Y])));not(not(trou([X,Y])))),assert(perdu));!),
	!.

/*******************************************/
/*****************JOUEUR********************/
/*******************************************/

/*******************IA**********************/

etapeSuivante :-
	getProchaineEtape(X,Y),
	bougerJoueur([X,Y]),
	!.

getProchaineEtape(X,Y) :-
	(
            (
                not(not(tresorTrouve)),
                not(not(ascenseurTrouve)),
                getAscenseur(X,Y,1,1)
	    );
	    getProchaineEtapeSafe(X,Y,0,0)
        ),
	!.

getProchaineEtapeSafe(X,Y,Xa,Ya) :-
	(
	     (
		 (Xa < 6, Xb is Xa, Yb is Ya);
		 (Xa > 5, Xb is 0, Yb is Ya + 1)
	     ),

             (
		   (
		         Ya > 5,
		         getProchaineEtapeNonSafe(X,Y,0,0)
		   );
	           (
	                 (
                              not(not(safe([Xb,Yb]))),
		              not(visite([Xb,Yb])),
			      X is Xb,
                              Y is Yb
	                 );
	                 (
		              Xc is Xb + 1,
	                      getProchaineEtapeSafe(X,Y,Xc,Yb)
		         )
		   )
	     )
	),
	!.

getProchaineEtapeNonSafe(X,Y,Xa,Ya) :-
	(
	     (
		 (Xa < 6, Xb is Xa, Yb is Ya);
		 (Xa > 5, Xb is 0, Yb is Ya + 1)
	     ),

             (
		   (
		         Ya > 5
	           );
	           (
	                 (
                              (not(not(maybeMonstre([Xb,Yb])));not(not(maybeTrou([Xb,Yb])))),
		              not(visite([Xb,Yb])),
			      X is Xb,
                              Y is Yb
	                 );
	                 (
		              Xc is Xb + 1,
	                      getProchaineEtapeNonSafe(X,Y,Xc,Yb)
		         )
		   )
	     )
	),
	!.

/*****************DIVERS********************/

tournerJoueur(X) :-
	retractall(direction(_)),
	assert(direction(X)),
	!.

bougerJoueur([X,Y]) :-
	format("Joueur: ~p ~p ~n", [X,Y]),
	retractall(joueur([_,_])),
	assert(joueur([X,Y])),
	miseAJourPredicat,
	!.

avancerJoueur :-
	getJoueur(X,Y,1,1),
	getDirection(D,1),
	(
	    (D == 1,Xb is X, Yb is Y + 1);
	    (D == 2,Xb is X + 1, Yb is Y);
	    (D == 3,Xb is X, Yb is Y - 1);
	    (D == 4,Xb is X - 1, Yb is Y)
	),
	(
	    not(not(mur([Xb,Yb])));
	    bougerJoueur([Xb,Yb])
	),
	!.

getDirection(D,X) :-
	X > 4;
	(
            not(direction(X)),
            Xb is X + 1,
            getDirection(D,Xb)
	);
	(
            not(not(direction(X))),
            D is X
	),
	!.

getJoueur(X,Y,Xa,Ya) :-
	(
           (
	       not(joueur([Xa,Ya])),
	       Xb is Xa + 1,
               (
		   (
			Xb > 4,
			Xc is 1,
			Yc is Ya + 1
		   );
		   (
			Xb < 5,
			Xc is Xb + 0,
			Yc is Ya + 0
		   )
	       ),
               getJoueur(X,Y,Xc,Yc)
	   );
	   (
	       not(not(joueur([Xa,Ya]))),
	       X is Xa + 0,
	       Y is Ya + 0
	   );
	   Ya > 5
	),
	!.

getAscenseur(X,Y,Xa,Ya) :-
	(
           (
	       not(ascenseur([Xa,Ya])),
	       Xb is Xa + 1,
               (
		   (
			Xb > 4,
			Xc is 1,
			Yc is Ya + 1
		   );
		   (
			Xb < 5,
			Xc is Xb + 0,
			Yc is Ya + 0
		   )
	       ),
               getAscenseur(X,Y,Xc,Yc)
	   );
	   (
	       not(not(ascenseur([Xa,Ya]))),
	       X is Xa + 0,
	       Y is Ya + 0
	   );
	   Ya > 5
	),
	!.


/*******************************************/
/*****************DIVERS********************/
/*******************************************/

estVide([X,Y]) :-
	not(monstre([X,Y])),
	not(mur([X,Y])),
	not(trou([X,Y])),
	not(joueur([X,Y])),
	not(ascenseur([X,Y])),
	not(tresor([X,Y])),
	!.

/*******************************************/
/****************AFFICHAGE******************/
/*******************************************/

afficherJeu(P) :-
	send(P, display, new(T, tabular)),
        send(T, border, 1),
        send(T, cell_spacing, -1),
        send(T, rules, all),
	afficherElements(T,0,5),
	send(T,next_row),
	(
	    (
	         not(not(gagner)),
		 send(T,append("Gagn�", bold, center, valign := center, colour := black, background := green, rowspan := 1, colspan := 6))
	    );
	    (
	         not(not(perdu)),
		 send(T,append("Perdu", bold, center, valign := center, colour := white, background := red, rowspan := 1, colspan := 6))
	    );
	    (
		 send(T,append("Recherche en cours...", bold, center, valign := center, colour := black, background := white, rowspan := 1, colspan := 6))
	    )
	),
	send(P, open),
	send(P,flush).

afficherElements(T,X,Y) :-
	(
                (
			X < 6,
			Xb is X + 0,
	                Yb is Y + 0
	        );
                (
		        X > 5,
		        Xb is 0,
			Yb is Y-1,
		        send(T,next_row)
		)
        ),
	(
	    Yb >= 0,
	    send(T,append(new(Q, tabular))),
	    (

		(
		     not(not(joueur([Xb,Yb]))),
		     send(Q,append("j", bold, center, valign := center, colour := black, background := cyan, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(monstre([Xb,Yb]))),
		     send(Q,append("m", bold, center, valign := center, colour := black, background := green, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(tresor([Xb,Yb]))),
		     send(Q,append("t", bold,  center, valign := center, colour := black, background := yellow, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(ascenseur([Xb,Yb]))),
		     send(Q,append("a", bold, center, valign := center, colour := black, background := orange, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(trou([Xb,Yb]))),
		     send(Q,append("t", bold, center, valign := center, colour := white, background := brown, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(mur([Xb,Yb]))),
		     send(Q,append("m", bold, center, valign := center, colour := white, background := black, rowspan := 2, colspan := 2))
	        );
		send(Q,append("c", bold, center, valign := center, colour := white, background := white, rowspan := 2, colspan := 2))
	    ),
	    (
		(
		     not(souffle([Xb,Yb])),
		     send(Q,append("s", bold, center, colour := white, background := gray))
	        );
		send(Q,append("s", bold, center, colour := white, background := red))
	    ),
	    (
		(
		     not(bruit([Xb,Yb])),
		     send(Q,append("b", bold, center, colour := white, background := gray))
	        );
		send(Q,append("b", bold, center, colour := white, background := purple))
	    ),
	    send(Q,next_row),
	    (
		(
		     not(odeur([Xb,Yb])),
		     send(Q,append("o", bold, center,colour := white, background := gray))
	        );
		send(Q,append("o", bold, center,colour := white, background := blue))
	    ),
	    (
		(
		     not(bling([Xb,Yb])),
		     send(Q,append("b", bold, center,colour := white, background := gray))
	        );
		send(Q,append("b", bold, center,colour := black, background := yellow))
	    ),
	    send(Q,next_row),
	    (
		(
		     not(not(sureMonstre([Xb,Yb]))),
		     send(Q,append(".m ", bold, center, colour := black, background := green))
	        );
		(
		     not(not(sureNotMonstre([Xb,Yb]))),
		     send(Q,append("!m ", bold, center, colour := white, background := red))
	        );
		(
		     not(not(maybeMonstre([Xb,Yb]))),
		     send(Q,append("?m", bold, center, colour := white, background := orange))
	        );
		send(Q,append("~m", bold, center, colour := white, background := gray))
	    ),
	    (
		(
		     not(not(sureTrou([Xb,Yb]))),
		     send(Q,append(".t", bold, center, colour := white, background := brown))
	        );
		(
		     not(not(sureNotTrou([Xb,Yb]))),
		     send(Q,append("!t ", bold, center, colour := white, background := red))
	        );
		(
		     not(not(maybeTrou([Xb,Yb]))),
		     send(Q,append("?t", bold, center, colour := white, background := orange))
	        );
		send(Q,append("~t", bold,  center,colour := white, background := gray))
	    ),
	    send(Q,append("s", bold, center, colour := white, background := white)),
	    send(Q,append("b", bold, center, colour := white, background := white)),
	    send(Q,next_row),
	    (
		(
		     not(not(sureAscenseur([Xb,Yb]))),
		     send(Q,append(".a", bold, center, colour := black, background := orange))
	        );
		(
		     not(not(sureNotAscenseur([Xb,Yb]))),
		     send(Q,append("!a ", bold, center, colour := white, background := red))
	        );
		(
		     not(not(maybeAscenseur([Xb,Yb]))),
		     send(Q,append("?a", bold, center, colour := white, background := orange))
	        );
		send(Q,append("~a", bold,  center,colour := white, background := gray))
	    ),

	    (
		(
		     not(not(sureTresor([Xb,Yb]))),
		     send(Q,append(".t", bold, center, colour := black, background := yellow))
	        );
		(
		     not(not(sureNotTresor([Xb,Yb]))),
		     send(Q,append("!t ", bold, center, colour := white, background := red))
	        );
		send(Q,append("~t", bold,  center,colour := white, background := gray))
	    ),
	    send(Q,append("o", bold, center, colour := white, background := white)),
	    (
		(
		     not(not(visite([Xb,Yb]))),
		     send(Q,append("v", bold, center,colour := black, background := beige))
	        );
		(
		     not(not(safe([Xb,Yb]))),
		     send(Q,append("s", bold, center,colour := black, background := green))
	        );
		send(Q,append("v", bold, center,colour := white, background := white))
	    ),
	    send(Q,append("t", bold,  center,colour := white, background := white)),

	    Xc is Xb + 1,
	    afficherElements(T,Xc,Yb)
	);
	!.
