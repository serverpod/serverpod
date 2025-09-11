// Example JavaScript file for static assets demo
console.log('Static assets example loaded!');

document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, static assets are working!');
    
    // Add some interactivity to demonstrate the JS is loaded
    const images = document.querySelectorAll('img');
    images.forEach(img => {
        img.addEventListener('click', function() {
            alert('Image clicked: ' + this.alt);
        });
    });
});
