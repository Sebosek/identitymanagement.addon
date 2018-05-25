import './Assets/skittles-0.1.0.min.css';

import { Main } from './Main.elm';

var app = Main.embed(document.getElementById('root'));

app.ports.copy.subscribe(function (data) {
    navigator.clipboard.writeText(data).then(function () {
        console.log('Async: Copying to clipboard was successful!');

        app.ports.copied.send('Copied');
    }, function (err) {
        console.error('Async: Could not copy text: ', err);
    });
});
