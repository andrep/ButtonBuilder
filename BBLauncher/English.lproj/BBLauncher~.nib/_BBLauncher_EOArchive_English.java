// _BBLauncher_EOArchive_English.java
// Generated by EnterpriseObjects palette at Wednesday, 18 April 2007 20:38:45 Europe/London

import com.webobjects.eoapplication.*;
import com.webobjects.eocontrol.*;
import com.webobjects.eointerface.*;
import com.webobjects.eointerface.swing.*;
import com.webobjects.foundation.*;
import javax.swing.*;

public class _BBLauncher_EOArchive_English extends com.webobjects.eoapplication.EOArchive {
    UserDefaultsController _userDefaultsController0;

    public _BBLauncher_EOArchive_English(Object owner, NSDisposableRegistry registry) {
        super(owner, registry);
    }

    protected void _construct() {
        Object owner = _owner();
        EOArchive._ObjectInstantiationDelegate delegate = (owner instanceof EOArchive._ObjectInstantiationDelegate) ? (EOArchive._ObjectInstantiationDelegate)owner : null;
        Object replacement;

        super._construct();

        _userDefaultsController0 = (UserDefaultsController)_registered(new UserDefaultsController(), "Shared Defaults");
    }

    protected void _awaken() {
        super._awaken();
    }

    protected void _init() {
        super._init();
    }
}
