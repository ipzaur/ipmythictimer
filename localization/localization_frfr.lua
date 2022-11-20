if GetLocale() ~= "frFR" then return end

local AddonName, Addon = ...

Addon.localization.ADDELEMENT = "Ajouter un élément"

Addon.localization.BACKGROUND = "Fond"
Addon.localization.BORDER     = "Bord"
Addon.localization.BORDERLIST = "Sélectionnez une bordure dans la bibliothèque"
Addon.localization.BOTTOM     = "Bas"
Addon.localization.BRDERWIDTH = "Largeur de la bordure"

Addon.localization.CLEANDBBT  = "Vider BDD"
Addon.localization.CLEANDBTT  = "Effacez la base interne de l'addon avec le pourcentage de monstres.\n" ..
                                "Aide si le compteur de pourcentage est bogué"
Addon.localization.CLOSE      = "Fermer"
Addon.localization.COLOR      = "Couleur"
Addon.localization.COLORDESCR = {
    TIMER = {
        [-1] = 'Couleur du timer si la clé est épuisée',
        [0]  = 'Couleur du timer si le temps est dans la plage pour +1',
        [1]  = 'Couleur du timer si le temps est dans la plage pour +2',
        [2]  = 'Couleur du timer si le temps est dans la plage pour +3',
    },
    OBELISKS = {
        [-1] = 'Couleur obélisque ouvert',
        [0]  = 'Couleur obélisque fermé',
    },
}
Addon.localization.COPY       = "Copier"
Addon.localization.CORRUPTED = {
    [161124] = "Urg'roth, bourreau des héros (Brise-armure)",
    [161241] = "Tisse-Vide Mal'thir (Araignée)",
    [161243] = "Samh'rek, harangueur du chaos (Peur)",
    [161244] = "Sang du Corrupteur (Blob)",
}

Addon.localization.DAMAGE     = "Dégâts"
Addon.localization.DECORELEMS = "Éléments décoratifs"
Addon.localization.DEFAULT    = "Défaut"
Addon.localization.DEATHCOUNT = "Morts"
Addon.localization.DEATHSHOW  = "Cliquez pour des informations détaillées"
Addon.localization.DEATHTIME  = "Temps perdu"
Addon.localization.DELETDECOR = "Supprimer l'élément décoratif"
Addon.localization.DIRECTION  = "Changement de progression"
Addon.localization.DIRECTIONS = {
    asc  = "Ascendant (0% -> 100%)",
    desc = "Descendant (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "Historique des morts"
Addon.localization.DEATHSHIDE = "Close deaths history" -- need correct
Addon.localization.DEATHSSHOW = "Show deaths history" -- need correct
Addon.localization.DTHCAPTFS  = "Caption font size" -- need correct
Addon.localization.DTHHEADFS  = "Column name font size" -- need correct
Addon.localization.DTHRCRDPFS = "Row font size" -- need correct

Addon.localization.ELEMENT    = {
    AFFIXES   = "Affixes actifs",
    BOSSES    = "Bosses",
    DEATHS    = "Morts",
    DUNGENAME = "Nom du donjon",
    LEVEL     = "Niveau",
    OBELISKS  = "Obélisques",
    PLUSLEVEL = "Up de clef",
    PLUSTIMER = "Temps jusqu'à ce que la clef soit baissée",
    PROGRESS  = "Trash tués",
    PROGNOSIS = "Pourcentage après pull",
    TIMER     = "Temps restant",
    TORMENT   = "Tourments",
}
Addon.localization.ELEMACTION =  {
    SHOW = "Afficher l'élément",
    HIDE = "Masquer l'élément",
    MOVE = "Déplacer l'élément",
}
Addon.localization.ELEMPOS    = "Emplacement de l'élément"

Addon.localization.FONT       = "Police"
Addon.localization.FONTSIZE   = "Taille de police"
Addon.localization.FONTSTYLE  = "Style de police"
Addon.localization.FONTSTYLES = {
    NORMAL  = "Normal",
    OUTLINE = "Contour",
    MONO    = "Monochrome",
    THOUTLN = "Contour épais",
}

Addon.localization.HEIGHT     = "Hauteur"
Addon.localization.HELP       = {
    AFFIXES    = "Affixes actifs",
    BOSSES     = "Boss tués",
    DEATHTIMER = "Temps perdu (morts)",
    LEVEL      = "Niveau de clef",
    PLUSLEVEL  = "Prochain niveau de clef",
    PLUSTIMER  = "Temps jusqu'à ce que la clef soit baissée",
    PROGNOSIS  = "Progression après avoir tué des mobs pull",
    PROGRESS   = "Trash tués",
    TIMER      = "Temps restant",
}

Addon.localization.ICONSIZE   = "Taille de l'icône"
Addon.localization.IMPORT     = "Importer"

Addon.localization.JUSTIFYH   = "Texte horizontal justifié"
Addon.localization.JUSTIFYV   = "Alignement vertical du texte" -- need correct

Addon.localization.LAYER      = "Étage"
Addon.localization.LEFT       = "Gauche"
Addon.localization.LIMITPRGRS = "Limit progress to 100%" -- need correct

Addon.localization.MAPBUT     = "LMB (click) - basculer les options\n" ..
                                "LMB (drag) - bouton de déplacement"
Addon.localization.MAPBUTOPT  = "Bouton Afficher/Masquer la mini-carte"
Addon.localization.MELEEATACK = "Attaque de mêlée"

Addon.localization.OPTIONS    = "Options"

Addon.localization.POINT      = "Point"
Addon.localization.PRECISEPOS = "Clic droit pour un positionnement précis"
Addon.localization.PROGFORMAT = {
    percent = "Pourcentage (100.00%)",
    forces  = "Forces (300)",
}
Addon.localization.PROGRESS   = "Format de progression"

Addon.localization.RELPOINT   = "Point relatif"
Addon.localization.RIGHT      = "Droite"

Addon.localization.SCALE      = "Échelle"
Addon.localization.SEASONOPTS = "Options de saison"
Addon.localization.SHROUDED   = {
    [189878] = "Infiltrateur nathrezim",
    [190128] = "Zul'gamux",
}
Addon.localization.SOURCE     = "Source"
Addon.localization.STARTINFO  = "iP Mythic Timer chargé. Tapez /ipmt pour les options."

Addon.localization.TEXTURE    = "Texture"
Addon.localization.TEXTURELST = "Sélectionnez une texture dans la bibliothèque"
Addon.localization.TXTCROP    = "Recadrer texture"
Addon.localization.TXTRINDENT = "Indentation de texture"
Addon.localization.TXTSETTING = "Paramètres de texture avancés"
Addon.localization.THEME      = "Thème"
Addon.localization.THEMEACTN  = {
    NEW    = "Créer un nouveau thème",
    COPY   = "Dupliquer le thème actuel",
    IMPORT = "Importer un thème",
    EXPORT = "Exporter le thème",
}
Addon.localization.THEMEBUTNS = {
    ACTIONS     = "Utiliser ce thème",
    DELETE      = "Supprimer le thème actuel",
    RESTORE     = 'Restaurer le thème "' .. Addon.localization.DEFAULT .. '" et sélectionnez-le',
    OPENEDITOR  = "Ouvrir l'éditeur de thème",
    CLOSEEDITOR = "Fermer l'éditeur de thème",
}
Addon.localization.THEMEDITOR = "Modifier le thème"
Addon.localization.THEMENAME  = "Nom du thème"
Addon.localization.TIMERDIRS  = {
    desc = "Descendant (36:00 -> 0:00)",
    asc  = "Ascendant (0:00 -> 36:00)",
}
Addon.localization.TIMERDIR   = "Sens du timer"
Addon.localization.TOP        = "Haut"
Addon.localization.TORMENTED  = {
    [179891] = "Soggodon le Briseur (Chaînes)",
    [179890] = "Exécuteur Varruth (Peur)",
    [179892] = "Oros Coeur-Algide (Glace)",
    [179446] = "Incinérateur Arkolath (Feu)",
}
Addon.localization.TIME       = "Temps"
Addon.localization.TIMERCHCKP = "Points de contrôle du timer"

Addon.localization.UNKNOWN    = "Inconnu"

Addon.localization.WAVEALERT  = "Alerter tous les {percent}%"
Addon.localization.WIDTH      = "Largeur"
Addon.localization.WHODIED    = "Qui est mort"
