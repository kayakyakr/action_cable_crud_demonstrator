var cable = Cable.createConsumer(window.location.origin.replace(/^http/, 'ws') + "/action_cable_demonstrator_cable");

export default cable;
