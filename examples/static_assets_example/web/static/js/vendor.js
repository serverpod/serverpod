// Example vendor JavaScript file for static assets demo
console.log('Vendor JS loaded!');

// Simulate a vendor library
window.VendorLib = {
    version: '1.0.0',
    init: function() {
        console.log('Vendor library initialized');
    }
};

// Auto-initialize
VendorLib.init();
