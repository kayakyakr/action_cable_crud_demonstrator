var cable = Cable.createConsumer((window.location.protocol == 'https:' ? 'wss://' : 'ws://') + window.location.host + "/toptal_cable");

export default cable;
