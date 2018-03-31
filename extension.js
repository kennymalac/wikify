let tabInfo;

browser.tabs.query({}).then((tabs) => {
  console.log(tabs);
  tabInfo = tabs.map(tab => {
    return {
      url: tab.url,
      title: tab.title,
      favIconUrl: tab.favIconUrl,
      windowId: tab.windowId
    };
  });
});
