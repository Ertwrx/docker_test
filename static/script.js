function toggleFullscreen(imageName) {
    var imageSrc = "/static/" + imageName;  // Assuming all images are in the static folder
    var fullscreenElement = document.createElement("div");
    fullscreenElement.classList.add("fullscreen");

    var imgElement = document.createElement("img");
    imgElement.src = imageSrc;

    fullscreenElement.appendChild(imgElement);
    document.body.appendChild(fullscreenElement);

    setTimeout(function() {
        fullscreenElement.remove();
    }, 5000); // 5 seconds
}
function playSound(soundId) {
    var audio = document.getElementById(soundId);
    audio.play();
}
